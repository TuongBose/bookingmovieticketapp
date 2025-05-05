package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.DTOs.BookingDTO;
import com.project.bookingmovieticketapp.DTOs.showtimeDTO;
import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Responses.ShowTimeResponse;
import com.project.bookingmovieticketapp.Services.ShowTime.ShowTimeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/showtimes")
@RequiredArgsConstructor
public class ShowTimeController {
    private final ShowTimeService showTimeService;

    @GetMapping("")
    public ResponseEntity<?> getShowTimeByMovieIdAndCinemaIdAndDate(
            @RequestParam int movieId,
            @RequestParam int cinemaId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        try {
            List<ShowTimeResponse> showTimeResponseList = showTimeService.getShowTimeByMovieIdAndCinemaIdAndDate(movieId, cinemaId, date);
            return ResponseEntity.ok(showTimeResponseList);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/cinemaanddate")
    public ResponseEntity<List<ShowTimeResponse>> getShowtimes(
            @RequestParam("cinemaId") int cinemaId,
            @RequestParam("date") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {
        List<ShowTimeResponse> showtimes = showTimeService.getShowtimesByCinemaIdAndDate(cinemaId, date);
        return ResponseEntity.ok(showtimes);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getShowTimeById(@Valid @PathVariable int id)
    {
        try{
            return ResponseEntity.ok(showTimeService.getShowTimeById(id));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateShowTimeStatus(
            @PathVariable int id,
            @RequestBody Map<String, Boolean> body) {
        try {
            boolean isActive = body.get("isActive");
            showTimeService.updateShowTimeStatus(id, isActive);
            return ResponseEntity.ok(Map.of("message", "Cập nhật trạng thái suất chiếu thành công."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/{id}/bookings-count")
    public ResponseEntity<?> getBookingsCountForShowTime(@PathVariable int id) {
        try {
            long bookingsCount = showTimeService.getBookingsCountForShowTime(id);
            return ResponseEntity.ok(bookingsCount);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<?> createShowtime(
            @RequestParam("movieid") int movieid,
            @RequestParam("roomid") int roomid,
            @RequestParam("showdate") String showdate,
            @RequestParam("starttime") String starttime,
            @RequestParam("price") int price
    ) {
        try {
            // Chuyển đổi showdate và starttime từ chuỗi thành LocalDate và LocalDateTime
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
            LocalDate parsedShowdate = LocalDate.parse(showdate, dateFormatter);
            LocalDateTime parsedStarttime = LocalDateTime.parse(starttime, dateTimeFormatter);

            // Tạo showtimeDTO
            showtimeDTO showtimeDTO = new showtimeDTO();
            showtimeDTO.setMovieid(movieid);
            showtimeDTO.setRoomid(roomid);
            showtimeDTO.setShowdate(parsedShowdate);
            showtimeDTO.setStarttime(parsedStarttime);
            showtimeDTO.setPrice(price);

            ShowTime createdShowtime = showTimeService.createShowTime(showtimeDTO);
            return ResponseEntity.ok(createdShowtime);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
