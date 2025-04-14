package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RoomDTO {
    private int cinemaid;
    private String name;
    private int seatcolumnmax;
    private int seatrowmax;
}
