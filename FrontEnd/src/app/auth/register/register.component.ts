import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { AuthService } from '../auth.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [RouterLink, ReactiveFormsModule],
  templateUrl: './register.component.html',
  styleUrl: './register.component.css'
})
export class RegisterComponent {
  registerForm: FormGroup;

  constructor(
    private formBuilder: FormBuilder, 
    private authService: AuthService
    ) {
    this.registerForm = this.formBuilder.group({
      first_name: ['', Validators.required],
      last_name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      birthday: ['', Validators.required],
      password: ['', Validators.required],
      c_password: ['', Validators.required],
      username: ['', Validators.required]
    });
  }

  onSubmit() {
    if (this.registerForm.valid) {
      const { 
        first_name,
        last_name,
        email,
        birthday, 
        password,
        c_password,
        username,
      } = this.registerForm.value;
      this.authService.register(
        first_name,
        last_name,
        email,
        birthday, 
        password,
        c_password,
        username,
      ).subscribe({
        next: (response) => {
          console.log('Inscription réussie', response);
          localStorage.setItem('token', response.accessToken);
        },
        error: (error) => {
          console.error('Erreur d\'inscription', error);
        }
      });
    }
  }
}