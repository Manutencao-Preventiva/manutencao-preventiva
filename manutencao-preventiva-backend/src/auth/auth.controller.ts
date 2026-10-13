import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Put,
} from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('cadastro')
  async cadastrar(
    @Body() body: { nome: string; email: string; senha: string },
  ) {
    return this.authService.cadastrar(body);
  }

  @Get('usuarios')
  async listarUsuarios() {
    return this.authService.listarUsuarios();
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(
    @Body() body: { email: string; senha: string },
  ) {
    return this.authService.login(body.email, body.senha);
  }

  @Put('perfil')
  async atualizarPerfil(
    @Body()
    body: {
      id?: number;
      email?: string;
      nome?: string;
      telefone?: string;
    },
  ) {
    return this.authService.atualizarPerfil(body);
  }

  @Get('perfil/:email')
  async obterPerfil(@Param('email') email: string) {
    return this.authService.obterPerfil(email);
  }
}