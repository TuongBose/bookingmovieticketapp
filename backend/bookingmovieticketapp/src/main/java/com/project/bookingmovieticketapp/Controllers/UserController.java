package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.DTOs.UserDTO;
import com.project.bookingmovieticketapp.DTOs.UserLoginDTO;
import com.project.bookingmovieticketapp.Models.User;
import com.project.bookingmovieticketapp.Services.User.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @PostMapping("/register")
    public ResponseEntity<?> createUser(@Valid @RequestBody UserDTO userDTO, BindingResult result) {
        try {
            if (result.hasErrors()) {
                List<String> errorMessages = result.getFieldErrors().stream().map(FieldError::getDefaultMessage).toList();
                return ResponseEntity.badRequest().body(errorMessages);
            }

            if(!userDTO.getPassword().equals(userDTO.getRetypepassword()))
                return ResponseEntity.badRequest().body("Xác nhận mật khẩu không khớp");

            User newUser = userService.createUser(userDTO);
            return ResponseEntity.ok(newUser);
        } catch (Exception e) {
            logger.error("Error creating User: ", e);
            return ResponseEntity.status(500).body("Internal Server Error: " + e.getMessage());
        }
    }

    @PostMapping("/login/customer")
    public ResponseEntity<?> loginCustomer(
            @Valid @RequestBody UserLoginDTO userLoginDTO,
            BindingResult result
    ) {
        try {
            if (result.hasErrors()) {
                List<String> errorMessages = result.getFieldErrors().stream().map(FieldError::getDefaultMessage).toList();
                return ResponseEntity.badRequest().body(errorMessages);
            }
            return ResponseEntity.ok(userService.loginCustomer(userLoginDTO.getPhonenumber(),userLoginDTO.getPassword()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/login/admin")
    public ResponseEntity<?> loginAdmin(
            @Valid @RequestBody UserLoginDTO userLoginDTO,
            BindingResult result
    ) {
        try {
            if (result.hasErrors()) {
                List<String> errorMessages = result.getFieldErrors().stream().map(FieldError::getDefaultMessage).toList();
                return ResponseEntity.badRequest().body(errorMessages);
            }
            return ResponseEntity.ok(userService.loginAdmin(userLoginDTO.getPhonenumber(),userLoginDTO.getPassword()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/admin")
    public ResponseEntity<?> getAllUserAdmin(){
        return ResponseEntity.ok(userService.getAllUserAdmin());
    }

    @GetMapping("/customer")
    public ResponseEntity<?> getAllUserCustomer(){
        return ResponseEntity.ok(userService.getAllUserCustomer());
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateUserStatus(
            @PathVariable int id,
            @RequestBody Map<String, Boolean> body) {
        try {
            boolean isActive = body.get("isActive");
            userService.updateUserStatus(id, isActive);
            return ResponseEntity.ok(Map.of("message", "Cập nhật trạng thái người dùng thành công."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // Endpoint để upload hình ảnh cho User
    @PostMapping("/{id}/image")
    public ResponseEntity<?> uploadUserImage(@PathVariable int id, @RequestParam("image") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "Không có tệp hình ảnh được gửi."));
            }

            // Kiểm tra định dạng file (chỉ cho phép hình ảnh)
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return ResponseEntity.badRequest().body(Map.of("error", "Tệp phải là hình ảnh (jpg, png, v.v.)."));
            }

            // Lấy User từ database
            User user;
            try {
                user = userService.getUserById(id);
                if (user == null) {
                    return ResponseEntity.notFound().build();
                }
            } catch (Exception e) {
                return ResponseEntity.badRequest().body(Map.of("error", "Không tìm thấy người dùng: " + e.getMessage()));
            }

            // Xóa file cũ nếu tồn tại
            if (user.getImagename() != null) {
                Path oldImagePath = Paths.get("images/users/" + user.getImagename());
                if (Files.exists(oldImagePath)) {
                    Files.delete(oldImagePath);
                }
            }

            // Lưu file mới
            Path uploadPath = Paths.get("images/users/");
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            String originalFileName = file.getOriginalFilename();
            String fileExtension = originalFileName != null && originalFileName.contains(".")
                    ? originalFileName.substring(originalFileName.lastIndexOf("."))
                    : ".jpg";
            String fileName = "user_" + id + "_" + System.currentTimeMillis() + fileExtension;
            Files.copy(file.getInputStream(), uploadPath.resolve(fileName));

            // Cập nhật trường imagename
            user.setImagename(fileName);
            userService.saveUser(user);

            return ResponseEntity.ok(Map.of("message", "Tải lên hình ảnh thành công."));
        } catch (IOException e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Lỗi khi lưu tệp: " + e.getMessage()));
        }
    }

    // Endpoint để lấy hình ảnh của User
    @GetMapping("/{id}/image")
    public ResponseEntity<?> getUserImage(@PathVariable int id) {
        try {
            User user;
            try {
                user = userService.getUserById(id);
                if (user == null || user.getImagename() == null) {
                    return ResponseEntity.notFound().build();
                }
            } catch (Exception e) {
                return ResponseEntity.badRequest().body(Map.of("error", "Không tìm thấy người dùng: " + e.getMessage()));
            }

            Path imagePath = Paths.get("images/users/" + user.getImagename());
            Resource resource = new UrlResource(imagePath.toUri());

            if (resource.exists() && resource.isReadable()) {
                // Xác định Content-Type dựa trên đuôi file
                String fileName = user.getImagename();
                MediaType mediaType = fileName.endsWith(".png") ? MediaType.IMAGE_PNG : MediaType.IMAGE_JPEG;
                return ResponseEntity.ok()
                        .contentType(mediaType)
                        .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (MalformedURLException e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Lỗi đường dẫn hình ảnh: " + e.getMessage()));
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@Valid @PathVariable int id) {
        try {
            return ResponseEntity.ok(userService.getUserById(id));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
