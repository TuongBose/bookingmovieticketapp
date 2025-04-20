package com.project.bookingmovieticketapp.Services.Cast;

import com.project.bookingmovieticketapp.Models.Cast;
import com.project.bookingmovieticketapp.Responses.CastResponse;

import java.util.List;

public interface ICastService {
    List<CastResponse> getCastByMovieId(int movieId) throws Exception;
}
