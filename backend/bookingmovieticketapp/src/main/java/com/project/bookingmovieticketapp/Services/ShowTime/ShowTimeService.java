package com.project.bookingmovieticketapp.Services.ShowTime;

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
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ShowTimeService implements IShowTimeService{
    private final ShowTimeRepository showTimeRepository;
    private final RoomRepository roomRepository;
    private final CinemaRepository cinemaRepository;
    private final MovieRepository movieRepository;

    @Override
    public List<ShowTime> getShowTimeByMovieIdAndCinemaIdAndDate(int movieId, int cinemaId, LocalDate date) throws Exception{
        Cinema existingCinema = cinemaRepository.findById(cinemaId)
                .orElseThrow(()-> new RuntimeException("Khong tim thay CinemaId"));

        Movie existingMovie = movieRepository.findById(movieId)
                .orElseThrow(()->new RuntimeException("Khong tim thay MovieId"));

        List<Room> rooms = roomRepository.findByCinemaId(existingCinema);
        List<Integer> roomIds = rooms.stream().map(Room::getId).toList();

        LocalDateTime start = date.atStartOfDay();
        LocalDateTime end = date.atTime(23, 59, 59);

        return showTimeRepository.findByMovieIdAndRoomIdInAndShowDateBetween(existingMovie, roomIds, start, end);
    }
}
