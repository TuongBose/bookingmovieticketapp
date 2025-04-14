package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

import java.util.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class MovieDTO {
    private String name;
    private String description;
    private int duration;
    private Date releasedate;
    private String posterurl;
    private String bannerurl;
    private String agerating;
    private float voteaverage;
    private String director;
}
