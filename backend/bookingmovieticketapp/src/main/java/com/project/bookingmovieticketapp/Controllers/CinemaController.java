package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.DTOs.CinemaDTO;
import com.project.bookingmovieticketapp.Models.Cinema;
import com.project.bookingmovieticketapp.Services.Cinema.CinemaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.hibernate.query.results.ResultBuilder;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("api/v1/cinemas")
@RequiredArgsConstructor
public class CinemaController {
    private final CinemaService cinemaService;

    @GetMapping("/movieandcityanddate")
    public ResponseEntity<List<Cinema>> getCinemaByMovieIdAndCity(
            @RequestParam int movieId,
            @RequestParam String city,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {

        return ResponseEntity.ok(cinemaService.getCinemaByMovieIdAndCityAndDate(movieId, city, date));
    }

    @GetMapping("")
    public ResponseEntity<List<Cinema>> getAllCinema() {
        return ResponseEntity.ok(cinemaService.getAllCinema());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getCinemaById(@Valid @PathVariable int id) {
        try {
            return ResponseEntity.ok(cinemaService.getCinemaById(id));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Endpoint để upload hình ảnh cho Cinema
    @PostMapping("/{id}/image")
    public ResponseEntity<?> uploadCinemaImage(@PathVariable int id, @RequestParam("image") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "Không có tệp hình ảnh được gửi."));
            }

            // Kiểm tra định dạng file (chỉ cho phép hình ảnh)
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return ResponseEntity.badRequest().body(Map.of("error", "Tệp phải là hình ảnh (jpg, png, v.v.)."));
            }

            // Lấy Cinema từ database
            Cinema cinema;
            try {
                cinema = cinemaService.getCinemaById(id);
                if (cinema == null) {
                    return ResponseEntity.notFound().build();
                }
            } catch (Exception e) {
                return ResponseEntity.badRequest().body(Map.of("error", "Không tìm thấy rạp chiếu phim: " + e.getMessage()));
            }

            // Xóa file cũ nếu tồn tại
            if (cinema.getImagename() != null) {
                Path oldImagePath = Paths.get("images/cinemas/" + cinema.getImagename());
                if (Files.exists(oldImagePath)) {
                    Files.delete(oldImagePath);
                }
            }

            // Lưu file mới
            Path uploadPath = Paths.get("images/cinemas/");
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            String originalFileName = file.getOriginalFilename();
            String fileExtension = originalFileName != null && originalFileName.contains(".")
                    ? originalFileName.substring(originalFileName.lastIndexOf("."))
                    : ".jpg";
            String fileName = "cinema_" + id + "_" + System.currentTimeMillis() + fileExtension;
            Files.copy(file.getInputStream(), uploadPath.resolve(fileName));

            // Cập nhật trường imagename
            cinema.setImagename(fileName);
            cinemaService.saveCinema(cinema);

            return ResponseEntity.ok(Map.of("message", "Tải lên hình ảnh thành công."));
        } catch (IOException e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Lỗi khi lưu tệp: " + e.getMessage()));
        }
    }

    // Endpoint để lấy hình ảnh của Cinema
    @GetMapping("/{id}/image")
    public ResponseEntity<?> getCinemaImage(@PathVariable int id) {
        try {
            Cinema cinema;
            try {
                cinema = cinemaService.getCinemaById(id);
                if (cinema == null || cinema.getImagename() == null) {
                    return ResponseEntity.notFound().build();
                }
            } catch (Exception e) {
                return ResponseEntity.badRequest().body(Map.of("error", "Không tìm thấy rạp chiếu phim: " + e.getMessage()));
            }

            Path imagePath = Paths.get("images/cinemas/" + cinema.getImagename());
            Resource resource = new UrlResource(imagePath.toUri());

            if (resource.exists() && resource.isReadable()) {
                // Xác định Content-Type dựa trên đuôi file
                String fileName = cinema.getImagename();
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

    @PostMapping(value = "", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> createCinema(
            @RequestPart("name") String name,
            @RequestPart("city") String city,
            @RequestPart("coordinates") String coordinates,
            @RequestPart("address") String address,
            @RequestPart("phonenumber") String phonenumber,
            @RequestPart("maxroom") String maxroomStr,
            @RequestPart(value = "image", required = false) MultipartFile file
    ) {
        try {
            // Kiểm tra các trường bắt buộc
            if (name == null || name.isEmpty() || city == null || city.isEmpty() ||
                    coordinates == null || coordinates.isEmpty() || address == null || address.isEmpty() ||
                    phonenumber == null || phonenumber.isEmpty() || maxroomStr == null || maxroomStr.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "Vui lòng điền đầy đủ thông tin."));
            }

            // Kiểm tra định dạng maxroom
            int maxroom;
            try {
                maxroom = Integer.parseInt(maxroomStr);
                if (maxroom <= 0) {
                    return ResponseEntity.badRequest().body(Map.of("error", "Số phòng chiếu tối đa phải lớn hơn 0."));
                }
            } catch (NumberFormatException e) {
                return ResponseEntity.badRequest().body(Map.of("error", "Số phòng chiếu tối đa phải là một số hợp lệ."));
            }

            // Kiểm tra định dạng tọa độ
            if (!coordinates.matches("^-?\\d+\\.\\d+\\s*,\\s*-?\\d+\\.\\d+$")) {
                return ResponseEntity.badRequest().body(Map.of("error", "Tọa độ phải có định dạng latitude,longitude (ví dụ: 10.7790,106.6918)."));
            }

            // Kiểm tra định dạng số điện thoại
            if (!phonenumber.matches("^0\\d{9,10}$")) {
                return ResponseEntity.badRequest().body(Map.of("error", "Số điện thoại phải bắt đầu bằng 0 và có 9-10 chữ số."));
            }

            // Tạo CinemaDTO
            CinemaDTO cinemaDTO = new CinemaDTO();
            cinemaDTO.setName(name);
            cinemaDTO.setCity(city);
            cinemaDTO.setCoordinates(coordinates);
            cinemaDTO.setAddress(address);
            cinemaDTO.setPhonenumber(phonenumber);
            cinemaDTO.setMaxroom(maxroom);

            // Tạo rạp
            Cinema cinema = cinemaService.createCinema(cinemaDTO);

            // Xử lý upload ảnh nếu có
            if (file != null && !file.isEmpty()) {
                String contentType = file.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    return ResponseEntity.badRequest().body(Map.of("error", "Tệp phải là hình ảnh (jpg, png, v.v.)."));
                }

                Path uploadPath = Paths.get("images/cinemas/");
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                String fileExtension = file.getOriginalFilename() != null && file.getOriginalFilename().contains(".")
                        ? file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."))
                        : ".jpg";
                String fileName = "cinema_" + cinema.getId() + "_" + System.currentTimeMillis() + fileExtension;
                Files.copy(file.getInputStream(), uploadPath.resolve(fileName));

                cinema.setImagename(fileName);
                cinemaService.saveCinema(cinema);
            }

            return ResponseEntity.ok(cinema);
        } catch (IOException e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Lỗi khi lưu tệp ảnh: " + e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Lỗi không xác định: " + e.getMessage()));
        }
    }

    @PostMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> updateCinema(@PathVariable int id, @ModelAttribute CinemaDTO cinemaDTO,
                                          @RequestPart(value = "image", required = false) MultipartFile file) {
        try {
            Cinema existingCinema = cinemaService.getCinemaById(id);
            if (existingCinema == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "Không tìm thấy rạp để cập nhật."));
            }

            existingCinema.setName(cinemaDTO.getName());
            existingCinema.setCity(cinemaDTO.getCity());
            existingCinema.setCoordinates(cinemaDTO.getCoordinates());
            existingCinema.setAddress(cinemaDTO.getAddress());
            existingCinema.setPhonenumber(cinemaDTO.getPhonenumber());
            existingCinema.setMaxroom(cinemaDTO.getMaxroom());
            existingCinema.setIsactive(cinemaDTO.isIsactive());
            Cinema updatedCinema = cinemaService.updateCinema(id, cinemaDTO);

            if (file.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "Không có tệp hình ảnh được gửi."));
            }

            // Kiểm tra định dạng file (chỉ cho phép hình ảnh)
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return ResponseEntity.badRequest().body(Map.of("error", "Tệp phải là hình ảnh (jpg, png, v.v.)."));
            }

            // Xóa file cũ nếu tồn tại
            if (updatedCinema.getImagename() != null) {
                Path oldImagePath = Paths.get("images/cinemas/" + updatedCinema.getImagename());
                if (Files.exists(oldImagePath)) {
                    Files.delete(oldImagePath);
                }
            }

            // Lưu file mới
            Path uploadPath = Paths.get("images/cinemas/");
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            String originalFileName = file.getOriginalFilename();
            String fileExtension = originalFileName != null && originalFileName.contains(".")
                    ? originalFileName.substring(originalFileName.lastIndexOf("."))
                    : ".jpg";
            String fileName = "cinema_" + id + "_" + System.currentTimeMillis() + fileExtension;
            Files.copy(file.getInputStream(), uploadPath.resolve(fileName));

            // Cập nhật trường imagename
            updatedCinema.setImagename(fileName);
            cinemaService.saveCinema(updatedCinema);

            return ResponseEntity.ok(updatedCinema);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Lỗi khi cập nhật rạp: " + e.getMessage()));
        }
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateCinemaStatus(
            @PathVariable int id,
            @RequestBody Map<String, Boolean> body) {
        try {
            boolean isActive = body.get("isActive");
            cinemaService.updateCinemaStatus(id, isActive);
            return ResponseEntity.ok(Map.of("message", "Cập nhật trạng thái cinema thành công."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
