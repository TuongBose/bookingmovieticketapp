package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.DTOs.MovieDTO;
import com.project.bookingmovieticketapp.Models.Movie;
import com.project.bookingmovieticketapp.Services.Movie.MovieService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/v1/movies")
@RequiredArgsConstructor
public class MovieController {
    private final MovieService movieService;

    @GetMapping("/nowplaying")
    public ResponseEntity<List<Movie>> getNowPlaying()
    {
        List<Movie> dsMovieNowPlaying = movieService.getNowPlaying();
        return ResponseEntity.ok(dsMovieNowPlaying);
    }

    @GetMapping("/upcoming")
    public ResponseEntity<List<Movie>> getUpComing(){
        List<Movie> dsMovieUpComing = movieService.getUpComing();
        return ResponseEntity.ok(dsMovieUpComing);
    }

    @GetMapping("/similar/{movieId}")
    public ResponseEntity<List<Movie>> getSimilarMovies(@PathVariable int movieId) {
        List<Movie> similarMovies = movieService.getSimilarMovies(movieId);
        return ResponseEntity.ok(similarMovies);
    }
}
