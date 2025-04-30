package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Booking;
import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;
import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Integer> {
    List<Booking> findByUserId(int userId);
    List<Booking> findByShowTimeId(int showTimeId);

    @Query(value = """
    SELECT m.id, m.name, COUNT(b.id) as total_bookings
    FROM movies m
    JOIN showtimes s ON s.movieid = m.id
    JOIN bookings b ON b.showtimeid = s.id
    WHERE b.bookingdate BETWEEN :startDate AND :endDate
    GROUP BY m.id, m.name
    ORDER BY total_bookings DESC
    LIMIT 1
    """, nativeQuery = true)
    List<Object[]> findMostBookedMovie(LocalDateTime startDate, LocalDateTime endDate);

    @Query(value = """
    SELECT SUM(b.totalprice)
    FROM bookings b
    WHERE b.bookingdate BETWEEN :startDate AND :endDate
    """, nativeQuery = true)
    Double calculateTotalRevenue(LocalDateTime startDate, LocalDateTime endDate);

    @Query(value = """
    SELECT c.id, c.name, COUNT(b.id) as total_bookings
    FROM cinemas c
    JOIN rooms ch ON ch.cinemaid = c.id
    JOIN showtimes s ON s.roomid = ch.id
    JOIN bookings b ON b.showtimeid = s.id
    WHERE b.bookingdate BETWEEN :startDate AND :endDate
    AND s.starttime BETWEEN :startDate AND :endDate
    GROUP BY c.id, c.name
    ORDER BY total_bookings DESC
    LIMIT 1
    """, nativeQuery = true)
    List<Object[]> findMostBookedCinema(LocalDateTime startDate, LocalDateTime endDate);

    // Thêm truy vấn: Phim được xem nhiều thứ 2
    @Query(value = """
        SELECT m.id, m.name, COUNT(b.id) as total_bookings
        FROM movies m
        JOIN showtimes s ON s.movieid = m.id
        JOIN bookings b ON b.showtimeid = s.id
        WHERE b.bookingdate BETWEEN :startDate AND :endDate
        AND s.starttime BETWEEN :startDate AND :endDate
        GROUP BY m.id, m.name
        ORDER BY total_bookings DESC
        LIMIT 1 OFFSET 1
        """, nativeQuery = true)
    List<Object[]> findSecondMostBookedMovie(LocalDateTime startDate, LocalDateTime endDate);

    // Thêm truy vấn: Phim được xem nhiều thứ 3
    @Query(value = """
        SELECT m.id, m.name, COUNT(b.id) as total_bookings
        FROM movies m
        JOIN showtimes s ON s.movieid = m.id
        JOIN bookings b ON b.showtimeid = s.id
        WHERE b.bookingdate BETWEEN :startDate AND :endDate
        AND s.starttime BETWEEN :startDate AND :endDate
        GROUP BY m.id, m.name
        ORDER BY total_bookings DESC
        LIMIT 1 OFFSET 2
        """, nativeQuery = true)
    List<Object[]> findThirdMostBookedMovie(LocalDateTime startDate, LocalDateTime endDate);
}
