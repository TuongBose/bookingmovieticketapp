package com.project.bookingmovieticketapp.Responses;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ShowTimeResponse {
    private int id;
    private int movieId;
    private int roomId;
    private LocalDate showdate;
    private LocalDateTime starttime;
    private int price;
    private boolean isactive;
}
