package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Models.Booking;
import com.project.bookingmovieticketapp.Models.BookingDetail;
import com.project.bookingmovieticketapp.Services.Booking.BookingService;
import com.project.bookingmovieticketapp.Services.BookingDetail.BookingDetailService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/bookings")
@RequiredArgsConstructor
public class BookingController {
    private final BookingService bookingService;

    @GetMapping("/showtimes/{showtimeId}/bookings")
    public ResponseEntity<?> getBookingsByShowtimeId(@Valid @PathVariable int showtimeId) {
        try {
            return ResponseEntity.ok(bookingService.getBookingByShowTimeId(showtimeId));
        }
        catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
