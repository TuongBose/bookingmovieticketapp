package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Models.Cinema;
import com.project.bookingmovieticketapp.Services.Cinema.CinemaService;
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
    public ResponseEntity<List<Cinema>> getAllCinema(){
        return ResponseEntity.ok(cinemaService.getAllCinema());
    }
}
