package com.project.bookingmovieticketapp.Responses;

import com.project.bookingmovieticketapp.Models.Room;
import jakarta.persistence.*;
import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SeatResponse {
    private int id;
    private int roomId;
    private String seatnumber;
}
