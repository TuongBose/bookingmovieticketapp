package com.project.bookingmovieticketapp.Services.Movie;

import com.project.bookingmovieticketapp.DTOs.MovieDTO;
import com.project.bookingmovieticketapp.Models.Movie;
import com.project.bookingmovieticketapp.Responses.TMDBNowPlayingResponse;
import com.project.bookingmovieticketapp.Responses.TMDBUpComingResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

import java.util.List;
import java.util.Map;

public interface IMovieService {
    Movie getMovieById(int id);
    Page<Movie> getAllMovie(PageRequest pageRequest);
    Movie updateMovie(int id, MovieDTO movieDTO);
    void deleteMovie(int id);
    boolean existsByName(String name);
}
