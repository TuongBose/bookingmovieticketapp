package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class CinemaDTO {
    private String name;
    private String city;
    private String coordinates;
    private String address;
    private String phonenumber;
    private int maxroom;
}
