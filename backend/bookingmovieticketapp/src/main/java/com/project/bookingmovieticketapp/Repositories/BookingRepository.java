package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Booking;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Integer> {
    List<Booking> findByUserId(int userId);
}
