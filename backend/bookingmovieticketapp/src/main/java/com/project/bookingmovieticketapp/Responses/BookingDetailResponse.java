package com.project.bookingmovieticketapp.Responses;

import com.project.bookingmovieticketapp.Models.Booking;
import com.project.bookingmovieticketapp.Models.Seat;
import jakarta.persistence.*;
import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookingDetailResponse {
    private int id;
    private int bookingId;
    private int seatId;
    private int price;
}
