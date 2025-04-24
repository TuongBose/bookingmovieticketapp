package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Movie;
import com.project.bookingmovieticketapp.Models.ShowTime;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface ShowTimeRepository extends JpaRepository<ShowTime,Integer> {
    List<ShowTime> findByMovieAndRoomIdInAndShowdateBetween(
            Movie movie, List<Integer> roomIds, LocalDateTime start, LocalDateTime end);
    List<ShowTime> findByMovieAndRoomIdInAndShowdate(
            Movie movie, List<Integer> roomIds, LocalDate date);
    List<ShowTime> findByMovieIdAndRoomIdIn(int movieId, List<Integer> roomIds);
    List<ShowTime> findByRoomIdAndShowdate(int movieId, LocalDate currentDate);

    @Query("SELECT s FROM ShowTime s WHERE s.room.id IN (SELECT r.id FROM Room r WHERE r.cinema.id = :cinemaId) AND s.showdate = :showdate")
    List<ShowTime> findByCinemaIdAndShowdate(@Param("cinemaId") int cinemaId, @Param("showdate") LocalDate showdate);
}
