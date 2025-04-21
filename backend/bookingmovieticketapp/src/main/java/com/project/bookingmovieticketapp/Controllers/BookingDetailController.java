package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.DTOs.BookingDTO;
import com.project.bookingmovieticketapp.DTOs.BookingDetailDTO;
import com.project.bookingmovieticketapp.Services.BookingDetail.BookingDetailService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/v1/bookingdetails")
@RequiredArgsConstructor
public class BookingDetailController {
    private final BookingDetailService bookingDetailService;

    @PostMapping("")
    public ResponseEntity<?> createBooking(
            @Valid @RequestBody BookingDetailDTO bookingDetailDTO,
            BindingResult result
    ) {
        try {
            if (result.hasErrors()) {
                List<String> errorMessage = result.getFieldErrors()
                        .stream()
                        .map(FieldError::getDefaultMessage)
                        .toList();
                return ResponseEntity.badRequest().body(errorMessage);
            }
            return ResponseEntity.ok(bookingDetailService.createBookingDetail(bookingDetailDTO));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

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
