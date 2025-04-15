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
    @NotBlank(message = "So dien thoai khong duoc bo trong")
    private String phonenumber;
    @NotBlank(message = "Password khong duoc bo trong")
    private String password;
}
