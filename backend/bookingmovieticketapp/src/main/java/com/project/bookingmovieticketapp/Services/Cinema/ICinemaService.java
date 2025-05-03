package com.project.bookingmovieticketapp.Services.Cinema;

import com.project.bookingmovieticketapp.DTOs.CinemaDTO;
import com.project.bookingmovieticketapp.Models.Cinema;
import org.springframework.cglib.core.Local;

import java.time.LocalDate;
import java.util.List;

public interface ICinemaService {
    Cinema createCinema(CinemaDTO cinemaDTO);
    Cinema updateCinema(int id, CinemaDTO cinemaDTO) throws Exception;
    List<Cinema> getAllCinema();
    List<Cinema> getCinemaByMovieIdAndCityAndDate(int movieId, String city, LocalDate date);
    Cinema getCinemaById(int id) throws Exception;
    void saveCinema(Cinema cinema);
}
