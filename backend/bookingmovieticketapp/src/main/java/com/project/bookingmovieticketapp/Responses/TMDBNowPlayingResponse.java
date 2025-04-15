package com.project.bookingmovieticketapp.Responses;

import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TMDBNowPlayingResponse {
    private Dates dates;
    private List<TMDBMovie> results;

    @Data
    public static class Dates {
        private String maximum;
        private String minimum;
    }

    @Data
    public static class TMDBMovie {
        private boolean adult;
        private String backdrop_path;
        private List<Integer> genre_ids;
        private int id;
        private String original_language;
        private String original_title;
        private String overview;
        private double popularity;
        private String poster_path;
        private String release_date;
        private String title;
        private boolean video;
        private double vote_average;
        private int vote_count;
    }
}
