package com.project.bookingmovieticketapp.Services.Movie;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.bookingmovieticketapp.DTOs.MovieDTO;
import com.project.bookingmovieticketapp.Models.Movie;
import com.project.bookingmovieticketapp.Repositories.MovieRepository;
import com.project.bookingmovieticketapp.Responses.TMDBNowPlayingResponse;
import com.project.bookingmovieticketapp.Responses.TMDBUpComingResponse;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.util.*;

@Service
@RequiredArgsConstructor
public class MovieService implements IMovieService {
    final MovieRepository movieRepository;

    @Value("${tmdb.api.key}")
    private String apiKey;

    @PostConstruct
    public void init() {
        syncMoviesFromTMDB();
    }

    LocalDate maximumNowPlaying;
    LocalDate minimumNowPlaying;

    LocalDate minimumUpComing;
    LocalDate maximumUpComing;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    private TMDBNowPlayingResponse getNowPlayingMovies() {
        String url = "https://api.themoviedb.org/3/movie/now_playing?api_key=" + apiKey + "&language=vi-VN&page=1";
        return restTemplate.getForObject(url, TMDBNowPlayingResponse.class);
    }

    private TMDBUpComingResponse getUpComingMovies() {
        String url = "https://api.themoviedb.org/3/movie/upcoming?api_key=" + apiKey + "&language=vi-VN&page=1";
        return restTemplate.getForObject(url, TMDBUpComingResponse.class);
    }

    // Phương thức getAgeCertification
    private String getAgeCertification(int movieId) {
        try {
            String url = "https://api.themoviedb.org/3/movie/" + movieId + "/release_dates?api_key=" + apiKey;
            String jsonResponse = restTemplate.getForObject(url, String.class);

            if (jsonResponse == null) {
                return "ALL";
            }

            Map<String, Object> responseMap = objectMapper.readValue(jsonResponse, new TypeReference<Map<String, Object>>() {
            });
            List<Map<String, Object>> results = (List<Map<String, Object>>) responseMap.get("results");

            Map<String, Object> country = null;
            for (Map<String, Object> result : results) {
                if ("US".equals(result.get("iso_3166_1"))) {
                    country = result;
                    break;
                }
            }

            if (country != null && country.get("release_dates") != null) {
                List<Map<String, Object>> releaseDates = (List<Map<String, Object>>) country.get("release_dates");
                if (!releaseDates.isEmpty()) {
                    String certification = (String) releaseDates.get(0).get("certification");
                    return mapAgeRating(certification);
                }
            }
            return "ALL";
        } catch (Exception e) {
            return "ALL";
        }
    }

    private String mapAgeRating(String certification) {
        if (certification == null || certification.isEmpty()) {
            return "ALL";
        }

        return switch (certification) {
            case "PG" -> "K";
            case "PG-13" -> "T13";
            case "R" -> "T16";
            case "NC-17" -> "C18";
            default -> "ALL";
        };
    }

    private void syncMoviesFromTMDB() {
        TMDBNowPlayingResponse responseNowPlaying = getNowPlayingMovies();
        if (responseNowPlaying != null && responseNowPlaying.getResults() != null) {
            maximumNowPlaying = LocalDate.parse(responseNowPlaying.getDates().getMaximum());
            minimumNowPlaying = LocalDate.parse(responseNowPlaying.getDates().getMinimum());
            for (TMDBNowPlayingResponse.TMDBMovie tmdbMovie : responseNowPlaying.getResults()) {
                // Kiểm tra xem phim đã tồn tại trong cơ sở dữ liệu chưa
                Movie existingMovie = movieRepository.findById(tmdbMovie.getId()).orElse(null);
                if (existingMovie == null) {
                    Movie newMovie = Movie.builder()
                            .id(tmdbMovie.getId()) // Dùng TMDb ID làm ID trong bảng movies
                            .name(tmdbMovie.getTitle())
                            .description(tmdbMovie.getOverview().isEmpty() ? "Chưa có thông tin" : tmdbMovie.getOverview())
                            .duration(0) // TMDb không cung cấp duration, bạn có thể thêm logic khác để lấy
                            .releasedate(LocalDate.parse(tmdbMovie.getRelease_date()))
                            .posterurl("https://image.tmdb.org/t/p/w500" + tmdbMovie.getPoster_path())
                            .bannerurl("https://image.tmdb.org/t/p/w1280" + tmdbMovie.getBackdrop_path())
                            .agerating(getAgeCertification(tmdbMovie.getId()))
                            .voteaverage(tmdbMovie.getVote_average())
                            .director(getDirector(tmdbMovie.getId()))
                            .build();
                    movieRepository.save(newMovie);
                }
            }
        }

        TMDBUpComingResponse responseUpComing = getUpComingMovies();
        if (responseUpComing != null && responseUpComing.getResults() != null) {
            maximumUpComing = LocalDate.parse(responseUpComing.getDates().getMaximum());
            minimumUpComing = LocalDate.parse(responseUpComing.getDates().getMinimum());
            for (TMDBUpComingResponse.TMDBMovie tmdbMovie : responseUpComing.getResults()) {
                Movie existingMovie = movieRepository.findById(tmdbMovie.getId()).orElse(null);
                if (existingMovie == null) {
                    Movie newMovie = Movie.builder()
                            .id(tmdbMovie.getId()) // Dùng TMDb ID làm ID trong bảng movies
                            .name(tmdbMovie.getTitle())
                            .description(tmdbMovie.getOverview().isEmpty() ? "Chưa có thông tin" : tmdbMovie.getOverview())
                            .duration(0) // TMDb không cung cấp duration, bạn có thể thêm logic khác để lấy
                            .releasedate(LocalDate.parse(tmdbMovie.getRelease_date()))
                            .posterurl("https://image.tmdb.org/t/p/w500" + tmdbMovie.getPoster_path())
                            .bannerurl("https://image.tmdb.org/t/p/w1280" + tmdbMovie.getBackdrop_path())
                            .agerating(getAgeCertification(tmdbMovie.getId()))
                            .voteaverage(tmdbMovie.getVote_average())
                            .director(getDirector(tmdbMovie.getId()))
                            .build();
                    movieRepository.save(newMovie);
                }
            }
        }
    }

    private String getDirector(int movieId) {
        try {
            String url = "https://api.themoviedb.org/3/movie/" + movieId + "/credits?api_key=" + apiKey;
            String jsonResponse = restTemplate.getForObject(url, String.class);

            if (jsonResponse == null) {
                return null;
            }

            Map<String, Object> responseMap = objectMapper.readValue(jsonResponse, new TypeReference<Map<String, Object>>() {
            });
            List<Map<String, Object>> crewList = (List<Map<String, Object>>) responseMap.get("crew");

            for (Map<String, Object> crew : crewList) {
                if ("Director".equals(crew.get("job"))) {
                    return (String) crew.get("name");
                }
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public List<Movie> getNowPlaying() {
        return movieRepository.findByReleasedateBetween(maximumNowPlaying,minimumNowPlaying);
    }

    @Override
    public List<Movie> getUpComing() {
        return movieRepository.findByReleasedateBetween(maximumUpComing,minimumUpComing);
    }

    @Override
    public Page<Movie> getAllMovie(PageRequest pageRequest) {
        return movieRepository.findAll(pageRequest);
    }

    @Override
    public boolean existsByName(String name) {
        return movieRepository.existsByName(name);
    }
}
