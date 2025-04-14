package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class SeatDTO {
    private int roomid;
    private String seatnumber;
}
