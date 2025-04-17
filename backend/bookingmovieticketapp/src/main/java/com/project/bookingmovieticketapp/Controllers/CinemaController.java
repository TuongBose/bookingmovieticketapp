package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Models.Cinema;
import com.project.bookingmovieticketapp.Services.Cinema.CinemaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/v1/cinemas")
@RequiredArgsConstructor
public class CinemaController {
    private final CinemaService cinemaService;

    @GetMapping("/movieandcity")
    public ResponseEntity<List<Cinema>> getCinemaByMovieIdAndCity(
            @RequestParam int movieId,
            @RequestParam String city) {

        return ResponseEntity.ok(cinemaService.getCinemaByMovieIdAndCity(movieId, city));
    }

    @GetMapping("")
    public ResponseEntity<List<Cinema>> getAllCinema(){
        return ResponseEntity.ok(cinemaService.getAllCinema());
    }
}
