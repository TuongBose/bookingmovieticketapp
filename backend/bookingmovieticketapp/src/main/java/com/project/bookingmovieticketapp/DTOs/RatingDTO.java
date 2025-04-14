package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RatingDTO {
    private int movieid;
    private int userid;
    private int rating;
    private String comment;
}
