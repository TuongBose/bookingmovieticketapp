package com.project.bookingmovieticketapp.Services.Cast;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.bookingmovieticketapp.Models.Cast;
import com.project.bookingmovieticketapp.Models.Movie;
import com.project.bookingmovieticketapp.Repositories.CastRepository;
import com.project.bookingmovieticketapp.Repositories.MovieRepository;
import com.project.bookingmovieticketapp.Responses.CastResponse;
import com.project.bookingmovieticketapp.Services.Cast.ICastService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CastService implements ICastService {

    private final MovieRepository movieRepository;
    private final CastRepository castRepository;

    @Override
    public List<CastResponse> getCastByMovieId(int movieId) throws Exception {
        Movie existingMovie = movieRepository.findById(movieId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay MovieId"));

        List<Cast> castList = castRepository.findByMovieId(movieId);
        List<CastResponse> castResponseList = new ArrayList<>();
        for(Cast cast : castList)
        {
            CastResponse newCastResponse= CastResponse
                    .builder()
                    .id(cast.getId())
                    .movieId(cast.getMovie().getId())
                    .actorname(cast.getActorname())
                    .build();

            castResponseList.add(newCastResponse);
        }
        return castResponseList;
    }
}