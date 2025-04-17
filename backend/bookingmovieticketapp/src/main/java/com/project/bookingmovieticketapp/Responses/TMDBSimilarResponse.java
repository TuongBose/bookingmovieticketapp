package com.project.bookingmovieticketapp.Responses;

import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TMDBSimilarResponse {
    private List<TMDBMovie> results;

    @Data
    public static class TMDBMovie {
        private int id;
    }
}
