package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Responses.ShowTimeResponse;
import com.project.bookingmovieticketapp.Services.ShowTime.ShowTimeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
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
}
