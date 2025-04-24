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
}
