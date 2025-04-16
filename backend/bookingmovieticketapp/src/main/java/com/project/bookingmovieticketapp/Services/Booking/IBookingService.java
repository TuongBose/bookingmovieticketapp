package com.project.bookingmovieticketapp.Services.Booking;

import com.project.bookingmovieticketapp.DTOs.BookingDTO;
import com.project.bookingmovieticketapp.Models.Booking;

import java.util.List;

public interface IBookingService {
    Booking createBooking(BookingDTO bookingDTO) throws Exception;
    List<Booking> getBookingByShowTimeId(int id) throws Exception;
    List<Booking> getBookingByUserId(int id) throws Exception;
    Booking getBookingById(int id) throws Exception;
    Booking updateBooking(int id, BookingDTO bookingDTO) throws Exception;
    void deleteBooking(int id) throws Exception;
}
