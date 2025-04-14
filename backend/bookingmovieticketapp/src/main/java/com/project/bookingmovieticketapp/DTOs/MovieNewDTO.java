package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

import java.util.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class MovieNewDTO {
    private String title;
    private String imageurl;
    private String type;
    private Date publishdate;
    private String content;
    private int movieid;
}
