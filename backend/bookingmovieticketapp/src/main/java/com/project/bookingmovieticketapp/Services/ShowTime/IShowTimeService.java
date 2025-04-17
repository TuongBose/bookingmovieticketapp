package com.project.bookingmovieticketapp.Services.ShowTime;

import com.project.bookingmovieticketapp.Models.ShowTime;

import java.time.LocalDate;
import java.util.List;

public interface IShowTimeService {
    List<ShowTime> getShowTimeByMovieIdAndCinemaIdAndDate(int movieId, int cinemaId, LocalDate date) throws Exception;
}
