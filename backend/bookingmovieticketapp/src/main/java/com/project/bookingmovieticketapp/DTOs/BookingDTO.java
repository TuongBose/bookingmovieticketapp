package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingDTO {
    private int userid;
    private int showtimeid;
    private int totalprice;
    private String paymentmethod;
    private String paymentstatus;
}
