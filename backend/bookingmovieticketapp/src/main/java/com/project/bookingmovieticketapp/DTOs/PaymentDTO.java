package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PaymentDTO {
    private int bookingid;
    private int totalprice;
    private String paymentmethod;
    private String paymentstatus;
    private LocalDateTime paymenttime;
}
