package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

import java.time.LocalDateTime;
import java.util.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class showtimeDTO {
    private int movieid;
    private int roomid;
    private Date showdate;
    private LocalDateTime starttime;
    private int price;
}
