package com.project.bookingmovieticketapp.DTOs;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserLoginDTO {
    @NotBlank(message = "Số điện thoại không được bỏ trống")
    private String phonenumber;
    @NotBlank(message = "Password không được bỏ trống")
    private String password;
}
