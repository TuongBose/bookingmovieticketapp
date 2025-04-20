package com.project.bookingmovieticketapp.Responses;

import com.project.bookingmovieticketapp.Models.Movie;
import jakarta.persistence.*;
import lombok.*;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CastResponse {
    private int id;
    private int movieId;
    private String actorname;
}
