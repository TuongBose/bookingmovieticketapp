package com.project.bookingmovieticketapp.Controllers;

import com.project.bookingmovieticketapp.Services.Cast.CastService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/v1/casts")
@RequiredArgsConstructor
public class CastController {
    private final CastService castService;

    @GetMapping("/{id}")
    public ResponseEntity<?> getCastByMovieId(@Valid @PathVariable int id) {
        try {
            return ResponseEntity.ok(castService.getCastByMovieId(id));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
