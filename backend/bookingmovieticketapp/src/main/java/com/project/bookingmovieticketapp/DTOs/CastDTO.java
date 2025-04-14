package com.project.bookingmovieticketapp.DTOs;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class CastDTO {
    private int movieid;
    private String actorname;
}
