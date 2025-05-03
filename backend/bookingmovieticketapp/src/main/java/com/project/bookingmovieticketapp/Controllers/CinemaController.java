package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Models.Cinema;
import com.project.bookingmovieticketapp.Services.Cinema.CinemaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
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
}
