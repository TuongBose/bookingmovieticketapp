package com.project.bookingmovieticketapp.Responses;

import com.project.bookingmovieticketapp.Models.Cinema;
import jakarta.persistence.*;
import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RoomResponse {
    private int id;
    private int cinemaId;
    private String name;
    private int seatcolumnmax;
    private int seatrowmax;
}
