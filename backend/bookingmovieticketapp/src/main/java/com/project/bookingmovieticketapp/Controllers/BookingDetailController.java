package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Services.BookingDetail.BookingDetailService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/v1/bookingdetails")
@RequiredArgsConstructor
public class BookingDetailController {
    private final BookingDetailService bookingDetailService;

    @GetMapping("/{bookingId}/details")
    public ResponseEntity<?> getBookingDetailsByBookingId(@PathVariable int bookingId) {
        try {
            return ResponseEntity.ok(bookingDetailService.getBookingDetailByBookingId(bookingId));
        }catch (Exception e)
        {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
