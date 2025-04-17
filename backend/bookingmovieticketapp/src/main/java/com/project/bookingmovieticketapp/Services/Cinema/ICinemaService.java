package com.project.bookingmovieticketapp.Services.Cinema;

import com.project.bookingmovieticketapp.DTOs.CinemaDTO;
import com.project.bookingmovieticketapp.Models.Cinema;

import java.util.List;

public interface ICinemaService {
    Cinema createCinema(CinemaDTO cinemaDTO);
    Cinema updateCinema(int id, CinemaDTO cinemaDTO) throws Exception;
    List<Cinema> getAllCinema();
    List<Cinema> getCinemaByMovieIdAndCity(int movieId, String city);
}
