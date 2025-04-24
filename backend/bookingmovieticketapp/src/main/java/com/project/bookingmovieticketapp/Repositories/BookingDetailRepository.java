package com.project.bookingmovieticketapp.Repositories;

import com.project.bookingmovieticketapp.Models.Booking;
import com.project.bookingmovieticketapp.Models.BookingDetail;
import com.project.bookingmovieticketapp.Models.Seat;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BookingDetailRepository extends JpaRepository<BookingDetail, Integer> {
    List<BookingDetail> findByBookingId(int bookingId);
}
