package com.project.bookingmovieticketapp.Services.Booking;

import com.project.bookingmovieticketapp.DTOs.BookingDTO;
import com.project.bookingmovieticketapp.Models.Booking;
import com.project.bookingmovieticketapp.Responses.BookingResponse;

import java.util.List;
import java.util.Map;

public interface IBookingService {
    Booking createBooking(BookingDTO bookingDTO) throws Exception;
    List<BookingResponse> getBookingByShowTimeId(int id) throws Exception;
    List<BookingResponse> getBookingByUserId(int id) throws Exception;
    Booking getBookingById(int id) throws Exception;
    Booking updateBooking(int id, BookingDTO bookingDTO) throws Exception;
    void deleteBooking(int id) throws Exception;
    int sumTotalPriceByUserId(int userId) throws Exception;
    Map<String, Object> getMostBookedMovie(int month, int year);
    double calculateMonthlyRevenue(int month, int year);
    Map<String, Object> getMostBookedCinema(int month, int year);
    Map<String, Object> getSecondMostBookedMovie(int month, int year);
    Map<String, Object> getThirdMostBookedMovie(int month, int year);
}
