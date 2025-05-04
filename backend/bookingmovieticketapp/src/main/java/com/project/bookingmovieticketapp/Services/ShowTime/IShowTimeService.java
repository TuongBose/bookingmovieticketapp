package com.project.bookingmovieticketapp.Services.ShowTime;

import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Responses.ShowTimeResponse;

import java.time.LocalDate;
import java.util.List;

public interface IShowTimeService {
    List<ShowTimeResponse> getShowTimeByMovieIdAndCinemaIdAndDate(int movieId, int cinemaId, LocalDate date) throws Exception;
    ShowTimeResponse getShowTimeById(int id) throws Exception;
    void updateShowTimeStatus(int id, boolean isActive) throws Exception;
    long getBookingsCountForShowTime(int showTimeId);
}
