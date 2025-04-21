package com.project.bookingmovieticketapp.Responses;

import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Models.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookingResponse {
    private int id;
    private int userId;
    private int showTimeId;
    private LocalDateTime bookingdate;
    private int totalprice;
    private String paymentmethod;
    private String paymentstatus;
    private boolean isactive;
}
