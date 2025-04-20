package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Responses.ShowTimeResponse;
import com.project.bookingmovieticketapp.Services.ShowTime.ShowTimeService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
}
