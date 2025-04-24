package com.project.bookingmovieticketapp.Services.Cinema;

import com.project.bookingmovieticketapp.DTOs.CinemaDTO;
import com.project.bookingmovieticketapp.Models.Cinema;
import com.project.bookingmovieticketapp.Models.Movie;
import com.project.bookingmovieticketapp.Models.Room;
import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Repositories.CinemaRepository;
import com.project.bookingmovieticketapp.Repositories.MovieRepository;
import com.project.bookingmovieticketapp.Repositories.RoomRepository;
import com.project.bookingmovieticketapp.Repositories.ShowTimeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CinemaService implements ICinemaService {
    private final CinemaRepository cinemaRepository;
    private final ShowTimeRepository showTimeRepository;
    private final RoomRepository roomRepository;
    private final MovieRepository movieRepository;

    @Override
    public Cinema createCinema(CinemaDTO cinemaDTO) {
        Cinema newCinema = Cinema
                .builder()
                .name(cinemaDTO.getName())
                .city(cinemaDTO.getCity())
                .coordinates(cinemaDTO.getCoordinates())
                .address(cinemaDTO.getAddress())
                .phonenumber(cinemaDTO.getPhonenumber())
                .imagename(cinemaDTO.getImagename())
                .build();
        cinemaRepository.save(newCinema);
        return newCinema;
    }

    @Override
    public Cinema updateCinema(int id, CinemaDTO cinemaDTO) throws Exception {
        Cinema existingCinema = cinemaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay CinemaId"));

        existingCinema.setName(cinemaDTO.getName());
        existingCinema.setCity(cinemaDTO.getCity());
        existingCinema.setCoordinates(cinemaDTO.getCoordinates());
        existingCinema.setAddress(cinemaDTO.getAddress());
        existingCinema.setPhonenumber(cinemaDTO.getPhonenumber());
        existingCinema.setMaxroom(cinemaDTO.getMaxroom());
        existingCinema.setImagename(cinemaDTO.getImagename());
        cinemaRepository.save(existingCinema);
        return existingCinema;
    }

    @Override
    public List<Cinema> getAllCinema() {
        return cinemaRepository.findAll();
    }

    // Lấy rạp chiếu phim (Cinemas) hiện đang chiếu phim (ByMovie) dựa vào lựa chọn thành phố (city)
    @Override
    public List<Cinema> getCinemaByMovieIdAndCityAndDate(int movieId, String city, LocalDate date) {
        // Tìm movie
        Movie movie = movieRepository.findById(movieId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay MovieId"));

        // Lấy tất cả rạp theo city (nếu city là "all" thì lấy tất cả)
        List<Cinema> cinemas = city.equals("all")
                ? cinemaRepository.findAll()
                : cinemaRepository.findByCity(city);

        // Lọc rạp có suất chiếu vào ngày date
        List<Cinema> filteredCinemas = new ArrayList<>();
        for (Cinema cinema : cinemas) {
            List<Room> rooms = roomRepository.findByCinema(cinema);
            List<Integer> roomIds = rooms.stream().map(Room::getId).toList();

            // Tìm showtimes theo movie, roomIds và date
            List<ShowTime> showTimes = showTimeRepository.findByMovieAndRoomIdInAndShowdate(movie, roomIds, date);
            if (!showTimes.isEmpty()) {
                filteredCinemas.add(cinema);
            }
        }
        return filteredCinemas;
    }

    @Override
    public Cinema getCinemaById(int id) throws Exception {
        return cinemaRepository.findById(id).orElseThrow(()->new RuntimeException("Khong tim thay CinemaId"));
    }
}
