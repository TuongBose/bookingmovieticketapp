package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingDetailDTO {
    private int bookingid;
    private int seatid;
    private int price;
}
