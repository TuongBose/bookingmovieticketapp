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
    List<Movie> getNowPlaying();
    List<Movie> getUpComing();
    List<Movie> getAllMovie();
    boolean existsByName(String name);
    Movie getMovieById(int id) throws Exception;
}
