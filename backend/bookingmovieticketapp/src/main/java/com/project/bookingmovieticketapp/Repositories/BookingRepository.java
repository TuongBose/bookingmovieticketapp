package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Booking;
import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Integer> {
    List<Booking> findByUserId(User userId);
    List<Booking> findByShowTimeId(ShowTime showTimeId);
}
