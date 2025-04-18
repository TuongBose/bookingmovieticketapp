package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Movie;
import com.project.bookingmovieticketapp.Models.ShowTime;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface ShowTimeRepository extends JpaRepository<ShowTime,Integer> {
    List<ShowTime> findByMovieAndRoomIdInAndShowdateBetween(
            Movie movie, List<Integer> roomIds, LocalDateTime start, LocalDateTime end);
    List<ShowTime> findByMovieIdAndRoomIdIn(int movieId, List<Integer> roomIds);
    List<ShowTime> findByRoomIdAndShowdate(int movieId, LocalDate currentDate);
}
